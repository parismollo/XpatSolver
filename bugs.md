# TESTS/BUGS
- Test 1
- Test 2
```bash
@@ -19,31 +18,31 @@ Fichier solution dune seul ligne (non adaptée à la partie)
 Fichier solution correct
 
   $ ../../src/XpatSolver.exe FreeCell.123 -check fc123.sol | tail -n 1
-  SUCCES
+  ECHEC 1
```


```bash

 Fichier solution correct
 
   $ ../../src/XpatSolver.exe FreeCell.123 -check fc123.sol | tail -n 1
-  SUCCES
+  LINE: 6 T MOVE: {source: 6; target: T} ECHEC 1

```
- Test 3
- Test 4
- Test 5
- Test 6
- Test 7
- Test 8

# TODO's

- [ ] voir partie dans pf5
- [ ] afficher player move
- [ ] afficher result de move