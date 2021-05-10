import os
import hashlib
import time

def scantree(path):
	"""Recursively yield DirEntry objects for given directory."""
	for entry in os.scandir(path):
		if entry.is_dir(follow_symlinks=False):
			yield from scantree(entry.path)
		else:
			yield entry

def  hashtrees(paths, buf_size=128 * 500):
	""" Hash every files from all given paths array (recursively)"""
	sha1 = hashlib.sha1()
	read_bytes = 0
	for path in paths:
		print(path+'/')
		for entry in scantree(path):
			if entry.is_file():
				read_bytes += os.stat(entry.path).st_size
				with open(entry.path, 'rb') as f:
					while data := f.read(buf_size):
						sha1.update(data)
			elif entry.is_dir():
				print("   "+entry.path+'/')

	return sha1.hexdigest(), read_bytes

def hash_itself():
	""" Get the hash of the script itself"""
	sha1 = hashlib.sha1()

	with open(__file__, 'rb') as f:
		while data := f.read():
			sha1.update(data)
	return sha1.hexdigest()

def dupplicate_path(paths):
	result=False
	seen = set()
	for x in paths:
		if x in seen:
			print(f"error dupplicate: {x}")
			result=True
		seen.add(x)
	return result



p=["/etc","/etc", "/var/log", "/var/spool", "/usr/local/sbin", "/var"]
# p += "/home/ggjulio/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games".split(sep=':')
p += os.environ["PATH"].split(sep=':')
#p+=["/var/log"]

start_time = time.time()
if dupplicate_path(p):
	exit(1)
hashe, read_bytes = hashtrees(p)

print("#" * 40)
print(f"Script  SHA1: {hash_itself()}")
print(f"Project SHA1: {hashe}")
print(f"--- {time.time() - start_time:.2f} seconds for {read_bytes/float(1<<30):.02f}GB ---")