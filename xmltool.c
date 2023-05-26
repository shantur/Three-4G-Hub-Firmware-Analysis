#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>

extern int crypt_decrypt_file2buffer_C(int fd, char *buffer);
extern int rand(void);

void logstr(char *msg)
{
    fprintf(stdout, "%s\n", msg);
    fflush(stdout);
}

int main(int argc, const char *argv[])
{
    int input_fd = 0;
    int output_fd = 0;
    int fileSize = 0;
    void *handle = NULL;
    int decryptResult = 0;

    if (argc < 3){
        logstr("Usage: ./xmltool <e|d> input.xml output.xml");
        logstr(" e = Encrypt Mode. -> output.xml should be a copy of encrypted file");
        logstr(" d = Decrypt Mode.");
        return 1;
    }

    char* operation = argv[1];
    char* inputFileName = argv[2];
    char* outputFileName = argv[3];

    input_fd = open(inputFileName, O_RDONLY);

    if(input_fd == 0) {
        logstr("Failed to open input file");
        return 1;
    }

    fileSize = lseek(input_fd, 0, SEEK_END);
    lseek(input_fd, 0, SEEK_SET);

    fprintf(stdout, "Input File Size : %d\n", fileSize);
    // fprintf(stdout, "Current Pointer : %d\n", ftell(input_fd));
    fflush(stdout);



    if (operation[0] == 'd') {
        output_fd = open(outputFileName, O_WRONLY | O_CREAT);
        logstr("Decrypting file");
        char* output_buff = (char *)malloc(fileSize + 0x10);
        decryptResult = crypt_decrypt_file2buffer_c(input_fd, output_buff);

        if (decryptResult > 0)
            write(output_fd, output_buff, decryptResult);

    } else if (operation[0] == 'e') {
        output_fd = open(outputFileName, O_RDWR, 0666);
        logstr("Encrypting file");
        char* input_buff =  (char *)malloc(fileSize);
        read(input_fd, input_buff, fileSize);

        char* key_info = (char *)malloc(0x60);
        lseek(output_fd, 100, SEEK_SET);
        read(output_fd, key_info, 0x60);
        ftruncate(output_fd, 200);
        lseek(output_fd, 0, SEEK_SET);

        decryptResult = crypt_encrypt_buffer2file_c(input_buff, fileSize, output_fd);

        //Fix encryption keys
        lseek(output_fd, 100, SEEK_SET);
        write(output_fd, key_info, 0x60);
    }

    if (decryptResult < 0)
    {
        fprintf(stderr, "Decryption / Encryption error: %s %d\n", inputFileName, decryptResult);
        return -1;
    }

    close(output_fd);

    fprintf(stdout, "Decryption result written to %s", outputFileName);

    close(input_fd);

    return 0;
}