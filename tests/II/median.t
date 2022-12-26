Certaines configurations initiales sont plutôt faciles à résoudre :

  $ timeout 120 ../../src/XpatSolver.exe bd.2 -search out.sol | tail -n 1
  SUCCES

  $ ../../src/XpatSolver.exe bd.2 -check out.sol | tail -n 1
  SUCCES

  $ timeout 120 ../../src/XpatSolver.exe fc.4 -search out.sol | tail -n 1
  SUCCES

  $ ../../src/XpatSolver.exe fc.4 -check out.sol | tail -n 1
  SUCCES

  $ timeout 120 ../../src/XpatSolver.exe bd.5 -search out.sol | tail -n 1
  SUCCES

  $ ../../src/XpatSolver.exe bd.5 -check out.sol | tail -n 1
  SUCCES

  $ timeout 120 ../../src/XpatSolver.exe st.7 -search out.sol | tail -n 1
  SUCCES

  $ ../../src/XpatSolver.exe st.7 -check out.sol | tail -n 1
  SUCCES

D'autres exemples :

st.1 fc.2 st.2 bd.2 fc.3 st.3 fc.4 st.4 st.5 bd.5 fc.6 st.6 fc.7 st.7 bd.7 fc.9
st.9 fc.11 fc.12 fc.13 st.13 bd.13 fc.15 st.15 st.16 fc.18 st.18 fc.19 st.20
fc.23 fc.25 st.25 st.26 bd.26 st.27 st.28 st.29 st.30 fc.31 bd.31 bd.32 fc.33
st.33 bd.36 st.37 bd.37 st.38 fc.40 fc.43 fc.44 fc.45 st.45 st.46 bd.46 st.47
fc.48 st.48 st.49 st.51 fc.53 bd.53 fc.54 st.54 fc.55 fc.56 fc.57 st.58 fc.59
st.59 st.60 bd.60 fc.61 fc.63 st.63 fc.64 st.64 bd.64 bd.65 fc.67 bd.67 bd.68
st.69 fc.70 st.71 bd.72 fc.75 st.76 fc.77 st.77 bd.77 fc.78 fc.79 st.79 fc.80
st.80 st.81 st.82 fc.83 fc.84 st.84 fc.86 fc.87 st.87 bd.87 fc.88 bd.88 bd.90
fc.91 fc.93 bd.93 st.94 bd.94 fc.96 st.96 st.97 bd.98 fc.99 st.99 fc.100 st.100


D'autres configurations insolubles sont modérément faciles à explorer de façon
exhaustive :

  $ timeout 120 ../../src/XpatSolver.exe st.56 -search out.sol | tail -n 1
  INSOLUBLE

  $ timeout 120 ../../src/XpatSolver.exe mo.5 -search out.sol | tail -n 1
  INSOLUBLE

  $ timeout 120 ../../src/XpatSolver.exe mo.6 -search out.sol | tail -n 1
  INSOLUBLE

  $ timeout 120 ../../src/XpatSolver.exe mo.7 -search out.sol | tail -n 1
  INSOLUBLE

D'autres exemples :

mo.5 mo.6 mo.7 mo.8 mo.12 mo.14 mo.15 mo.16 mo.18 mo.19 mo.29 mo.30 mo.34 mo.35
mo.36 mo.37 mo.38 mo.39 mo.41 mo.42 mo.43 mo.45 mo.46 mo.47 mo.52 mo.54 st.56
mo.56 mo.62 mo.64 mo.65 mo.67 mo.68 mo.71 mo.72 mo.78 mo.79 mo.82 mo.87 mo.88
mo.89 mo.91 mo.95 mo.96 mo.97 mo.99 mo.100
