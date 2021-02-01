{ mkShell, pgbr }:

mkShell {
  name = "pgbr-env";

  buildInputs = [ pgbr ];
}