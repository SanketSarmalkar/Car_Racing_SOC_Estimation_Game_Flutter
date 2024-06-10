class Matrix {
  List<List<num>> eye(int size) {
    List<List<num>> identityMatrix =
        List.generate(size, (i) => List.filled(size, 0.0));
    for (int i = 0; i < size; i++) {
      identityMatrix[i][i] = 1.0;
    }
    return identityMatrix;
  }

  List<num> dotMultiply(List<num> a, num b) {
    for (int i = 0; i < a.length; i++) {
      a[i] *= b;
    }
    return a;
  }

  List<List<num>> dotMultiply2D(List<List<num>> a, num b) {
    for (int i = 0; i < a.length; i++) {
      for (int j = 0; j < a[i].length; j++) {
        a[i][j] *= b;
      }
    }
    return a;
  }

  // Static method for matrix multiplication
  dynamic multiply(dynamic a, dynamic b) {
    if (a is List<List<num>> && b is List<List<num>>) {
      // Matrix-matrix multiplication
      return _matrixMultiply(a, b);
    } else if (a is List<List<num>> && b is List<num>) {
      // Matrix-vector multiplication
      return _matrixVectorMultiply(a, b);
    } else if (a is List<num> && b is List<List<num>>) {
      // Vector-matrix multiplication
      return _vectorMatrixMultiply(a, b);
    } else if (a is List<num> && b is List<num>) {
      return _vectorMultiply(a, b);
    } else {
      throw Exception('Invalid types for multiplication');
    }
  }

  List<List<num>> _matrixMultiply(List<List<num>> a, List<List<num>> b) {
    int rowsA = a.length;
    int colsA = a[0].length;
    int colsB = b[0].length;

    // Initialize the result matrix with zeros
    List<List<num>> result =
        List.generate(rowsA, (_) => List.filled(colsB, 0.0));

    for (int i = 0; i < rowsA; i++) {
      for (int j = 0; j < colsB; j++) {
        for (int k = 0; k < colsA; k++) {
          result[i][j] += a[i][k] * b[k][j];
        }
      }
    }

    return result;
  }

  List<num> _matrixVectorMultiply(List<List<num>> matrix, List<num> vector) {
    int rows = matrix.length;
    int cols = matrix[0].length;

    if (vector.length != cols) {
      throw Exception('Matrix columns must match vector length');
    }

    // Initialize the result vector with zeros
    List<num> result = List.filled(rows, 0.0);

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        result[i] += matrix[i][j] * vector[j];
      }
    }

    return result;
  }

  List<num> _vectorMatrixMultiply(List<num> vector, List<List<num>> matrix) {
    int rows = matrix.length;
    int cols = matrix[0].length;

    if (vector.length != rows) {
      throw Exception('Vector length must match matrix rows');
    }

    // Initialize the result vector with zeros
    List<num> result = List.filled(cols, 0.0);

    for (int j = 0; j < cols; j++) {
      for (int i = 0; i < rows; i++) {
        result[j] += vector[i] * matrix[i][j];
      }
    }

    return result;
  }

  List<List<num>> _vectorMultiply(List<num> a, List<num> b) {
    List<List<num>> result = [];
    for (int i = 0; i < a.length; i++) {
      List<num> row = [];
      for (int j = 0; j < b.length; j++) {
        row.add(a[i] * b[j]);
      }
      result.add(row);
    }
    return result;
  }

  // Static method for matrix addition
  dynamic add(dynamic a, dynamic b) {
    if (a is List<List<num>> && b is List<List<num>>) {
      return _matrixAdd(a, b);
    } else if (a is List<List<num>> && b is List<num>) {
      return _matrixVectorAdd(a, b);
    } else if (a is List<num> && b is List<List<num>>) {
      return _vectorMatrixAdd(a, b);
    } else if (a is List<num> && b is List<num>) {
      return _vectorAdd(a, b);
    } else {
      throw Exception('Invalid types for addition');
    }
  }

  static List<List<num>> _matrixAdd(List<List<num>> a, List<List<num>> b) {
    int rows = a.length;
    int cols = a[0].length;

    // Initialize the result matrix with zeros
    List<List<num>> result = List.generate(rows, (_) => List.filled(cols, 0.0));

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        result[i][j] = a[i][j] + b[i][j];
      }
    }

    return result;
  }

  static List<num> _matrixVectorAdd(List<List<num>> matrix, List<num> vector) {
    int rows = matrix.length;
    int cols = matrix[0].length;

    if (vector.length != cols) {
      throw Exception('Matrix columns must match vector length');
    }

    // Initialize the result vector with zeros
    List<num> result = List.filled(rows, 0.0);

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        result[i] += matrix[i][j] + vector[j];
      }
    }

    return result;
  }

  static List<num> _vectorMatrixAdd(List<num> vector, List<List<num>> matrix) {
    int rows = matrix.length;
    int cols = matrix[0].length;

    if (vector.length != rows) {
      throw Exception('Vector length must match matrix rows');
    }

    // Initialize the result vector with zeros
    List<num> result = List.filled(cols, 0.0);

    for (int j = 0; j < cols; j++) {
      for (int i = 0; i < rows; i++) {
        result[j] += vector[i] + matrix[i][j];
      }
    }

    return result;
  }

  static List<num> _vectorAdd(List<num> a, List<num> b) {
    int length = a.length;

    if (b.length != length) {
      throw Exception('Vectors must be of the same length');
    }

    // Initialize the result vector with zeros
    List<num> result = List.filled(length, 0.0);

    for (int i = 0; i < length; i++) {
      result[i] = a[i] + b[i];
    }

    return result;
  }

  // Static method for matrix subtraction
  dynamic subtract(dynamic a, dynamic b) {
    if (a is List<List<num>> && b is List<List<num>>) {
      return _matrixSubtract(a, b);
    } else if (a is List<List<num>> && b is List<num>) {
      return _matrixVectorSubtract(a, b);
    } else if (a is List<num> && b is List<List<num>>) {
      return _vectorMatrixSubtract(a, b);
    } else if (a is List<num> && b is List<num>) {
      return _vectorSubtract(a, b);
    } else {
      throw Exception('Invalid types for subtraction');
    }
  }

  static List<List<num>> _matrixSubtract(List<List<num>> a, List<List<num>> b) {
    int rows = a.length;
    int cols = a[0].length;

    // Initialize the result matrix with zeros
    List<List<num>> result = List.generate(rows, (_) => List.filled(cols, 0.0));

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        result[i][j] = a[i][j] - b[i][j];
      }
    }

    return result;
  }

  static List<num> _matrixVectorSubtract(
      List<List<num>> matrix, List<num> vector) {
    int rows = matrix.length;
    int cols = matrix[0].length;

    if (vector.length != cols) {
      throw Exception('Matrix columns must match vector length');
    }

    // Initialize the result vector with zeros
    List<num> result = List.filled(rows, 0.0);

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        result[i] += matrix[i][j] - vector[j];
      }
    }

    return result;
  }

  static List<num> _vectorMatrixSubtract(
      List<num> vector, List<List<num>> matrix) {
    int rows = matrix.length;
    int cols = matrix[0].length;

    if (vector.length != rows) {
      throw Exception('Vector length must match matrix rows');
    }

    // Initialize the result vector with zeros
    List<num> result = List.filled(cols, 0.0);

    for (int j = 0; j < cols; j++) {
      for (int i = 0; i < rows; i++) {
        result[j] += vector[i] - matrix[i][j];
      }
    }

    return result;
  }

  static List<num> _vectorSubtract(List<num> a, List<num> b) {
    int length = a.length;

    if (b.length != length) {
      throw Exception('Vectors must be of the same length');
    }

    // Initialize the result vector with zeros
    List<num> result = List.filled(length, 0.0);

    for (int i = 0; i < length; i++) {
      result[i] = a[i] - b[i];
    }

    return result;
  }

  // Static method for matrix transpose
  List<dynamic> transpose(dynamic matrix) {
    if (matrix is List<List<num>>) {
      // If matrix is a 2D list
      int rows = matrix.length;
      int cols = matrix[0].length;

      // Initialize the transposed matrix with dimensions flipped
      List<List<num>> transposed =
          List.generate(cols, (_) => List.filled(rows, 0.0));

      for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
          transposed[j][i] = matrix[i][j];
        }
      }

      return transposed;
    } else if (matrix is List<num>) {
      // If matrix is a 1D list (vector), convert it to a column vector
      List<List<num>> transposed =
          List.generate(matrix.length, (index) => [matrix[index]]);
      return transposed;
    } else {
      throw ArgumentError('Input matrix type not supported');
    }
  }

  // Static method for matrix inverse
  List<dynamic> inverse(dynamic matrix) {
    if (matrix is List<List<num>>) {
      // If matrix is a 2D list
      if (matrix.length != matrix[0].length) {
        throw ArgumentError('Matrix must be square for inversion');
      }

      int n = matrix.length;
      List<List<num>> identity = List.generate(
          n, (i) => List.generate(n, (j) => (i == j ? 1.0 : 0.0)));

      // Create an augmented matrix [matrix | identity]
      List<List<num>> augmented =
          List.generate(n, (i) => List.from(matrix[i])..addAll(identity[i]));

      // Perform Gaussian elimination to obtain the inverse
      for (int i = 0; i < n; i++) {
        num pivot = augmented[i][i];
        for (int j = i; j < 2 * n; j++) {
          augmented[i][j] /= pivot;
        }
        for (int k = 0; k < n; k++) {
          if (k != i) {
            num factor = augmented[k][i];
            for (int j = 0; j < 2 * n; j++) {
              augmented[k][j] -= factor * augmented[i][j];
            }
          }
        }
      }

      // Extract the right half of the augmented matrix (the inverse)
      List<List<num>> inverseMatrix = [];
      for (int i = 0; i < n; i++) {
        inverseMatrix.add(augmented[i].sublist(n));
      }

      return inverseMatrix;
    } else {
      throw ArgumentError('Input matrix type not supported');
    }
  }
}
