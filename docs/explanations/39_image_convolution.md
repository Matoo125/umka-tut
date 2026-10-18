# Exercise 39: 2D Image Kernel Filter & Convolution

## Objective

Implement a 2D discrete convolution engine in Umka and Lua capable of applying spatial filter kernels (such as Laplacian Edge Detection and Box Blur) across grayscale image matrices, incorporating boundary clamping and ASCII art intensity rendering.

---

## Core Concepts

### 1. 2D Discrete Convolution
Spatial convolution computes each output pixel $(x, y)$ as a weighted sum of the input pixel's local neighborhood defined by an odd-sized kernel matrix (here, $3 \times 3$):

$$O(x, y) = \text{clamp}\left(\frac{1}{D} \sum_{ky=-1}^{1} \sum_{kx=-1}^{1} I(x + kx, y + ky) \cdot K(ky + 1, kx + 1) + B, 0, 255\right)$$

Where:
- $I(x, y)$ is the input pixel intensity.
- $K(j, i)$ is the kernel weight matrix.
- $D$ is the normalization divisor (e.g. $9$ for uniform box blur, $1$ for edge detection).
- $B$ is an optional bias offset.
- $\text{clamp}(v, 0, 255)$ constrains pixel results within valid byte intensity ranges.

### 2. Boundary Handling: Border Clamping
Pixels near the matrix boundaries require sampling outside the valid coordinate space $[0, W-1] \times [0, H-1]$.
Using **clamping** (replicate edge pixels):
$$x_{\text{clamped}} = \max(0, \min(W - 1, x))$$
$$y_{\text{clamped}} = \max(0, \min(H - 1, y))$$
This avoids out-of-bounds index errors while preserving boundary continuity without artificial black borders.

### 3. Filter Kernels
1. **Laplacian Ridge / Edge Detector**:
   $$\begin{bmatrix} -1 & -1 & -1 \\ -1 & 8 & -1 \\ -1 & -1 & -1 \end{bmatrix}, \quad D = 1$$
   Highlights rapid intensity changes (boundaries and sharp transitions) while zeroing out flat regions.
2. **Box Blur (Uniform Low-Pass Filter)**:
   $$\begin{bmatrix} 1 & 1 & 1 \\ 1 & 1 & 1 \\ 1 & 1 & 1 \end{bmatrix}, \quad D = 9$$
   Averages the surrounding $3 \times 3$ neighborhood, attenuating high-frequency noise and smoothing transitions.

---

## Umka vs. Lua Implementation Nuances

| Feature | Umka | Lua |
| :--- | :--- | :--- |
| **Matrix Storage** | 1D dynamic slice `[]int` with width and height in a struct `Image` | 1D table `data[i]` indexed $1 \dots W \times H$ |
| **Row-Major Offset** | `y * img.w + x` (0-based) | `y * self.w + x + 1` (1-based) |
| **Kernel Representation** | Fixed-size array `[9]int` inside `Kernel3x3` struct | Table `{ weights = { ... }, divisor = 9, bias = 0 }` |
| **String / ASCII Mapping** | Direct byte indexing `ramp[shadeIdx]` | 1-based table lookup `ramp[shadeIdx]` |

---

## Sample Run & Visual Output

```text
=== 2D Image Convolution & Kernel Filter ===
Source Image (5x5):
   0   0   0   0   0
   0 200 200 200   0
   0 200 200 200   0
   0 200 200 200   0
   0   0   0   0   0
Source Image (ASCII):
          
  - - -   
  - - -   
  - - -   
          

Laplacian Edge Detection (5x5):
   0   0   0   0   0
   0 255 255 255   0
   0 255   0 255   0
   0 255 255 255   0
   0   0   0   0   0
Laplacian Edge Detection (ASCII):
          
  # # #   
  #   #   
  # # #   
          

Box Blur (3x3) (5x5):
  22  44  66  44  22
  44  88 133  88  44
  66 133 200 133  66
  44  88 133  88  44
  22  44  66  44  22
Box Blur (3x3) (ASCII):
    .     
  . : .   
. : - : . 
  . : .   
    .     

Convolution pipeline completed successfully.
```

---

## Common Pitfalls

1. **In-Place Modification**: Never overwrite the source image matrix while reading neighborhood pixels for convolution; always allocate a separate output matrix `res` and write to it.
2. **Clamping Negative Values**: Edge detection filters contain negative weights. Without clamping to 0, negative values can corrupt display routines or underflow unsigned byte representations.
3. **Divisor by Zero**: When normalizing filters with arbitrary divisors, guard against `divisor == 0`.
