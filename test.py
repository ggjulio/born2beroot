import os
import hashlib
import time

paths=["/etc", "/var/log", "/var/spool"]
paths += os.environ["PATH"].split(sep=':')

paths=["/home/ggjulio/Documents/"]
paths=["/home/ggjulio/VirtualBox VMs/born2beroot"]

def scantree(path):
    """Recursively yield DirEntry objects for given directory."""
    for entry in os.scandir(path):
        if entry.is_dir(follow_symlinks=False):
            yield from scantree(entry.path)
        else:
            yield entry

def  hashtrees(paths=[], buf_size=128 * 500):
	""" Hash every files from all given paths (recursively)"""
	sha1 = hashlib.sha1()
	read_bytes = 0
	for path in paths:
		print(path)
		for entry in scantree(path):
			if entry.is_file():
				read_bytes += os.stat(entry.path).st_size
				with open(entry.path, 'rb') as f:
					while data := f.read(buf_size):
						sha1.update(data)
	return read_bytes



start_time = time.time()

# hashtrees(paths)
print(f"{__file__}")
print(f"--- {time.time() - start_time} seconds for {read_bytes/float(1<<30)}GB ---")
print(f"SHA1: {sha1.hexdigest()}")
# myhash = hashlib.sha1("Foxe".encode('utf-8'))
# print(myhash.hexdigest())


# with os.scandir('/etc') as it:
# 	for entry in it:
# 		if entry.is_file():
# 			print(entry)
# 			with open("/etc/resolv.conf", 'rb') as f:
# 				while data := f.read(buf_size):
# 					sha1.update(data)
