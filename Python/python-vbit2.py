import struct
import subprocess

def getch():
    print("Python version:")
    subprocess.run(["python", "--version"])

    if struct.calcsize("P") * 8 == 64:
        print("Running in 64-bit mode.")
    else:
        print("Running in 32-bit mode.")

    print("\nOther versions:")
    subprocess.run(["cmake", "--version"])
    subprocess.run(["git", "--version"])
    subprocess.run(["pip", "--version"])
    subprocess.run(["autobuild", "--version"])
    
    #subprocess.run(["pip", "install", "llbase"])
    #subprocess.run(["pip", "install", "git+https://github.com/secondlife/autobuild.git#egg=autobuild"])
    #subprocess.run(["pip", "install", "llsd"])

    #print("\nCloning Firestorm repository:")
    #subprocess.run(["git", "clone", "https://github.com/FirestormViewer/phoenix-firestorm-alpha phoenix-firestorm-alpha"])
    # subprocess.run(["git", "clone", "https://github.com/FirestormViewer/fs-build-variables.git fs-build-variables"])

getch()
