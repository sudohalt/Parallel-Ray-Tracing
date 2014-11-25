/* Funcitons to simplify copying, allocating, and freeing on GPU */

void *AllocateDevice(size_t);
void CudaMemCpyToSymbol(void *, void *, size_t);
void CopyToDevice(void *, void *, size_t);
void CopyFromDevice(void *, void *, size_t);
void FreeDevice(void *);
~
