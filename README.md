# LFSR-and-Stream-Cipher

LFSR.m builds a 22-bit LFSR (Linear Feedback Shift Register) to generate pseudo random numbers. These random numbers are then flushed into a text file called my_random_numbers, which will be used in StreamCipher.m.

StreamCipher.m encrypts an image using Shannon's One time key method. A message of m-bits XOR'd with a key of perfectly random numbers of m-bits that converts plaintext to ciphertext.

Example - Orignal Image, Encrypted Image, Decrypted Image

![image](https://user-images.githubusercontent.com/59804756/194739231-4f5f095b-2380-46f5-a3a6-cce779cb26d0.png)
