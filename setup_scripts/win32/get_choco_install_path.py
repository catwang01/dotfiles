"""
Script and function to get the path of a chocolatey install
matching the `pathComponent`, or, if none provided, the
last installed path.
@author Philip Kahn
@date 20230614
@license MIT
@url https://gist.github.com/tigerhawkvok/aad3f184b37bb869df5bd337d4b4c22e
"""

import subprocess
import re
from pathlib import Path
import warnings
from typing import Optional
import argparse
import os


def getChocoInstalledPath(pathComponent: Optional[str] = None) -> Path:
    """
    Spawn a subprocess to get the last installed path of a chocolatey package.
    Parameters
    ----------
    pathComponent : Optional[str]
        A known path component of the path to be found.
        If `None`, the last installed path is returned.
    Returns
    -------
    Path
    Raises
    ------
    ValueError
    """
    if pathComponent == "":
        pathComponent = None
    
    # Properly handle Windows environment variables
    program_data = os.getenv('PROGRAMDATA')
    if not program_data:
        raise ValueError("Cannot retrieve PROGRAMDATA environment variable")
    
    log_path = Path(program_data) / "chocolatey" / "logs" / "choco.summary.log"
    
    try:
        with open(log_path, 'r') as f:
            log_content = f.read()
    except FileNotFoundError:
        raise ValueError(f"Chocolatey log file not found: {log_path}")
    except Exception as e:
        raise ValueError(f"Error reading log file: {str(e)}")
    
    # Use more flexible regex matching
    matches = re.findall(r"Deployed to '([^']+)'", log_content)
    if not matches:
        # Try alternate matching pattern
        matches = re.findall(r"Software installed to '([^']+)'", log_content)
    
    if not matches:
        raise ValueError("No Chocolatey installation paths found")
    
    # Filter paths if pathComponent is provided
    if pathComponent:
        matching_paths = [p for p in matches if pathComponent.lower() in p.lower()]
        if not matching_paths:
            raise ValueError(f"No installation path containing '{pathComponent}' found")
        return Path(matching_paths[-1])
    
    # Otherwise return the last matched path
    return Path(matches[-1])

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Get the path of a chocolatey install matching the pathComponent, or, if none provided, the last installed path")
    parser.add_argument('pathComponent', type=str, nargs='?',
                        help='a known path component of the path to be found')
    args = parser.parse_args()
    
    try:
        print(getChocoInstalledPath(args.pathComponent))
    except ValueError as e:
        print(f"Error: {str(e)}")
    except Exception as e:
        print(f"An unexpected error occurred: {str(e)}")