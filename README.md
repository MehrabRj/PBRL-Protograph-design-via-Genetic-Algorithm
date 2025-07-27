This MATLAB code designs protograph of a rate-compatible LDPC Codes in
Protograph-Based Raptor-like (PBRL) LDPC codes structure which
optimizes decoding threshold of the protograph via genetic algorithm.
It minimizes norm of gap-to-capacity threshold, reducing threshold in
every single rate simultanously.

- **Goal**: Design protographs for PBRL LDPC codes with optimized decoding thresholds.
- **Method**: Genetic algorithm to search the protograph space.
- **Tool**: EXIT chart-based threshold estimation and Genetic Algorithm
- **Language**: MATLAB

🚀 How to Run

1. Open MainGA in MATLAB.
2. Set the HRC submatrix of PBRL graph and parameters n_r(number of rates), n_v(number of variable nodes in HRC),
 n_c(number of check nodes in HRC) and I and 0 submatrices(all zero and identity matrices with proper dimensions).
3. Run untill a significantly low gap-to-capacity threshold norm is observed.


### 📌 Attribution

This project includes adapted code from:

- Lcrypto, [Protograph_EXIT_chart](https://github.com/Lcrypto/Protograph_EXIT_chart)
  Licensed under the Apache License 2.0



