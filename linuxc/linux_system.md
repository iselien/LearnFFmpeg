Linux的系统编程有三个基石：系统调用、C链接库以及C编译器。

系统调用需要进行模式切换，而每个完整的应用程序都有两个栈，一个用户栈，一个内核栈，这两个栈是独立的，用户栈在用户空间，内核栈在内核空间，因此切换模式时，栈也得切换。

