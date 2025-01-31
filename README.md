# asm
ASM source code examples

# Assemble

for convenience we use the GNU assembler to produce an object file with debugging symbols:

```sh
as -g code.asm -o code.o
```

this is so that we can check the register values with GDB later.

# Link

We use the linker to produce the executable, in our repository we only have programs that
are comprised by only one source file so that is done in this way:

```sh
ld code.o -o code.bin
```

if we wanted to strip all symbols we could also link it in this other way:

```sh
ld -s code.o -o code.bin
```

# Debug

```sh
gdb ./code.bin
```

to get info about the registers use

```sh
i r
```

and to get info about an specific register use

```sh
i r reg
```

where `reg` is the register name `rax`, `rbx`, etc.

# Execute

```sh
./code.bin
```

# Errors

the following cli tool can help a lot to understand the error codes returned by the
Linux kernel:

```sh
errno -l
```

the tool is provided by the `moreutils` package.
