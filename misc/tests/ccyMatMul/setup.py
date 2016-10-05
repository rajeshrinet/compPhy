from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
import numpy

# get the annotated file as well
import Cython.Compiler.Options
Cython.Compiler.Options.annotate = True

ext_modules = [
    Extension("matMul",
              sources=["matMul.pyx", "cMatMul.c"],
              include_dirs=[numpy.get_include()],
              extra_link_args=['-fopenmp'],
              libraries=[]), # Unix-like specific
    
]
setup(
    cmdclass = {'build_ext': build_ext},
    ext_modules = ext_modules
)

