CC=gcc
CFLAGS=-I. -Wall -lpthread
DEPS=config.h client.h encryption.h md5.h logger.h resend.h debug_utils env.h
OBJS=main.o client.o encryption.o md5.o logger.o resend.o debug_utils.o env.o
TARGET=jlu-drcom-client

# object: dependence
# $@: left side of `:`
# $<: first parameter
%.o: %.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

# $^: right side of `:`
$(TARGET): $(OBJS)
	$(CC) -o $@ $^ $(CFLAGS)

.PHONY: clean

clean:
	rm $(TARGET) $(OBJS)