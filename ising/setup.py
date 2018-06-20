import numpy
import os, sys, os.path, tempfile, subprocess, shutil
from distutils.core import setup
from Cython.Build import cythonize
import Cython.Compiler.Options
Cython.Compiler.Options.annotate = True
from distutils.extension import Extension
from Cython.Distutils import build_ext

def check_for_openmp():
    ##Adapted from Goldbaum reply. See https://github.com/pynbody/pynbody/issues/124
    # Create a temporary directory
    tmpdir = tempfile.mkdtemp()
    curdir = os.getcwd()
    os.chdir(tmpdir)

    # Get compiler invocation
    compiler = os.getenv('CC', 'cc')

    # Attempt to compile a test script.
    # See http://openmp.org/wp/openmp-compilers/
    filename = r'test.c'
    file = open(filename,'w', 0)
    file.write(
        "#include <omp.h>\n"
        "#include <stdio.h>\n"
        "int main() {\n"
        "#pragma omp parallel\n"
        "printf(\"Hello from thread %d, nthreads %d\\n\", omp_get_thread_num(), omp_get_num_threads());\n"
        "}")
    with open(os.devnull, 'w') as fnull:
        exit_code = subprocess.call([compiler, '-fopenmp', filename],
                                    stdout=fnull, stderr=fnull)
    # Clean up
    file.close()
    os.chdir(curdir)
    shutil.rmtree(tmpdir)

    if exit_code == 0:
        return True
    else:
        return False

if check_for_openmp() == True:
    omp_args = ['-fopenmp']
else:
    omp_args = None

ext_modules=[
    Extension("ising",
              sources=["core/ising.pyx", "core/cIsing.c"],
              include_dirs=[numpy.get_include()],
              extra_compile_args=omp_args,
              extra_link_args=omp_args,
              libraries=[]), # Unix-like specific
]

setup(
  cmdclass = {'build_ext': build_ext},
  ext_modules = ext_modules
  )
