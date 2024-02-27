import logging
import argparse
import os
import plistlib
import shutil
import subprocess
from pathlib import Path

this_dir = Path(__file__).parent

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

def run_command(command: str):
    ret = subprocess.run(command, 
                         shell=True, 
                         stdout=subprocess.PIPE, 
                         stderr=subprocess.PIPE)
    return ret.stdout.decode('utf-8')

def generate_plist(template_path: str, output_path: str):
    with open(template_path, 'rb') as f:
        plist = plistlib.load(f)

    plist['WorkingDirectory'] = str(this_dir)
    plist['ProgramArguments'] = ['./run.sh']
    plist['StandardErrorPath'] = str(this_dir / 'kanata-error.log')
    plist['StandardOutPath'] = str(this_dir / 'kanata-local.log')

    with open(output_path, 'wb') as f:
        plistlib.dump(plist, f)
    
    shutil.chown(output_path, user='root')

def move_to_dir(output_file_name: str, dir_path: Path):
    shutil.move(output_file_name, dir_path)

def copy_to_target_directory_and_load(output_file_name: str, dir_path: Path):
    move_to_dir(output_file_name, dir_path)
    output_file_path = dir_path / output_file_name
    run_command(f'launchctl unload -w {output_file_path}')
    run_command(f'launchctl load -w {output_file_path}')

def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('-f', '--force', action='store_true', default=False)
    args = parser.parse_args()
    return args

def main():
    args = get_args()
    template_path = 'dotfiles-kanata.plist.template'
    output_file_name = 'dotfiles-kanata.plist'
    generate_plist(template_path, output_file_name)
    agent_dir = Path('/Library/LaunchDaemons')
    output_file_path = agent_dir / output_file_name

    if output_file_path.exists():
        if args.force:
            answer = input('Do you want to overwrite the existing plist file? [y/N] ')
            if answer.lower() != 'y':
                print('Abort.')
                return
            os.remove(output_file_path)
            logger.info('File removed.')
            copy_to_target_directory_and_load(output_file_name, agent_dir)
        else:
            print(f'File already exists: {output_file_path}')
    else:
        copy_to_target_directory_and_load(output_file_name, agent_dir)

if __name__ == '__main__':
    main()