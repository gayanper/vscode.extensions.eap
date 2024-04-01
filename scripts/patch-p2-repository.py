import os
import zipfile

P2_REPOSITORY_JDTINCU = './jdt-repo-releng/target/repository-jdtincu'
P2_REPOSITORY_ECLIPSE = './jdt-repo-releng/target/repository-eclipse'

dirs = ['./extensions/jdt.core', './extensions/jdt.debug', './extensions/jdt.ui']
# find all *.jar files in the above directories recursively in dirs variable
source_jar_map = {}
repo_jar_map = {}

print ('Patching p2-repository')
for dir in dirs:
    for root, subdirs, files in os.walk(dir):
        for file in files:
            if file.endswith('SNAPSHOT.jar'):
                name = file.split('-')[0]
                source_jar_map.update({name: os.path.abspath(os.path.join(root, file))})
                
for root, subdirs, files in os.walk(os.path.join(P2_REPOSITORY_ECLIPSE, 'plugins')):
    for file in files:
        if file.endswith('.jar'):
            name = file.split('_')[0]
            repo_jar_map.update({name: os.path.abspath(os.path.join(root, file))})

# processing after eclipse will make sure we update the incubator instead of eclipse
for root, subdirs, files in os.walk(os.path.join(P2_REPOSITORY_JDTINCU, 'plugins')):
    for file in files:
        if file.endswith('.jar'):
            name = file.split('_')[0]
            repo_jar_map.update({name: os.path.abspath(os.path.join(root, file))})

for name, source_jar_path in source_jar_map.items():
    repo_jar_path = repo_jar_map.get(name)
    if repo_jar_path is not None:
        print('Patching ' + repo_jar_path + ' with ' + source_jar_path)

        # replace all files in repo_jar_path except files in META-INF from source_jar_path
        with zipfile.ZipFile(repo_jar_path + '.modified', 'w') as repo_jar_w:
            with zipfile.ZipFile(repo_jar_path, 'r') as repo_jar:
                with zipfile.ZipFile(source_jar_path, 'r') as source_jar:
                    repo_name_list = repo_jar.namelist()
                    for file in source_jar.namelist():
                        if file.startswith('META-INF'):
                            if not (file.endswith('ECLIPSE_.RSA') or file.endswith('ECLIPSE_.SF')):
                                repo_jar_w.writestr(file, '')
                            
                                if file.endswith('MANIFEST.MF'):
                                    # cleanup manifest
                                    lines = source_jar.read(file).decode('utf-8').splitlines()
                                    for line in lines:
                                        if line.startswith('Name:') or line.startswith('SHA-256-Digest:'):
                                            continue
                                        repo_jar_w.writestr(file, line + '\n', compress_type=zipfile.ZIP_STORED)

                                info = repo_jar.getinfo(file)
                                repo_jar_w.writestr(file, repo_jar.read(file), compress_type=info.compress_type)
                        else:
                            if file in repo_name_list:
                                info = repo_jar.getinfo(file)
                                repo_jar_w.writestr(file, source_jar.read(file), compress_type=info.compress_type)
                            else:
                                repo_jar_w.writestr(file, source_jar.read(file), compress_type=zipfile.ZIP_STORED)

        os.remove(repo_jar_path)
        os.rename(repo_jar_path + '.modified', repo_jar_path)

        print('Patched ' + repo_jar_path + ' with ' + source_jar_path)

print ('Done patching p2-repository')