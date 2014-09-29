from setuptools import setup,find_packages

setup(
    name='scamall',
    version='0.0.1',
    description='distributed web crawler / poetry generator',
    author='vilmibm shaksfrpease',
    packages = find_packages(),
    include_package_data = True,
    install_requires = [
        'celery==3.1.15',
        'redis==2.10.3',
        'requests==2.4.1',
        'prosaic==1.0.0b1'
    ]
)
