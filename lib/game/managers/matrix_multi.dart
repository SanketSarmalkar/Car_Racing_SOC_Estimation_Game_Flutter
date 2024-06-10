class Matrix {
  List<List<double>> eye(int size) {
    List<List<double>> identityMatrix =
        List.generate(size, (i) => List.filled(size, 0.0));
    for (int i = 0; i < size; i++) {
      identityMatrix[i][i] = 1.0;
    }
    return identityMatrix;
  }

  List<double> dotMultiply(List<double> a, double b) {
    for (int i = 0; i < a.length; i++) {
      a[i] *= b;
    }
    return a;
  }

  List<List<double>> dotMultiply2D(List<List<double>> a, double b) {
    for (int i = 0; i < a.length; i++) {
      for (int j = 0; j < a[i].length; j++) {
        a[i][j] *= b;
      }
    }
    return a;
  }

  // Static method for matrix multiplication
  dynamic multiply(dynamic a, dynamic b) {
    if (a is List<List<double>> && b is List<List<double>>) {
      // Matrix-matrix multiplication
      return _matrixMultiply(a, b);
    } else if (a is List<List<double>> && b is List<double>) {
      // Matrix-vector multiplication
      return _matrixVectorMultiply(a, b);
    } else if (a is List<double> && b is List<List<double>>) {
      // Vector-matrix multiplication
      return _vectorMatrixMultiply(a, b);
    } else if (a is List<double> && b is List<double>) {
      return _vectorMultiply(a, b);
    } else {
      throw Exception('Invalid types for multiplication');
    }
  }

  List<List<double>> _matrixMultiply(
      List<List<double>> a, List<List<double>> b) {
    int rowsA = a.length;
    int colsA = a[0].length;
    int colsB = b[0].length;

    // Initialize the result matrix with zeros
    List<List<double>> result =
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

  List<double> _matrixVectorMultiply(
      List<List<double>> matrix, List<double> vector) {
    int rows = matrix.length;
    int cols = matrix[0].length;

    if (vector.length != cols) {
      throw Exception('Matrix columns must match vector length');
    }

    // Initialize the result vector with zeros
    List<double> result = List.filled(rows, 0.0);

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        result[i] += matrix[i][j] * vector[j];
      }
    }

    return result;
  }

  List<double> _vectorMatrixMultiply(
      List<double> vector, List<List<double>> matrix) {
    int rows = matrix.length;
    int cols = matrix[0].length;

    if (vector.length != rows) {
      throw Exception('Vector length must match matrix rows');
    }

    // Initialize the result vector with zeros
    List<double> result = List.filled(cols, 0.0);

    for (int j = 0; j < cols; j++) {
      for (int i = 0; i < rows; i++) {
        result[j] += vector[i] * matrix[i][j];
      }
    }

    return result;
  }

  List<List<double>> _vectorMultiply(List<double> a, List<double> b) {
    List<List<double>> result = [];
    for (int i = 0; i < a.length; i++) {
      List<double> row = [];
      for (int j = 0; j < b.length; j++) {
        row.add(a[i] * b[j]);
      }
      result.add(row);
    }
    return result;
  }

  // Static method for matrix addition
  dynamic add(dynamic a, dynamic b) {
    if (a is List<List<double>> && b is List<List<double>>) {
      return _matrixAdd(a, b);
    } else if (a is List<List<double>> && b is List<double>) {
      return _matrixVectorAdd(a, b);
    } else if (a is List<double> && b is List<List<double>>) {
      return _vectorMatrixAdd(a, b);
    } else if (a is List<double> && b is List<double>) {
      return _vectorAdd(a, b);
    } else {
      throw Exception('Invalid types for addition');
    }
  }

  static List<List<double>> _matrixAdd(
      List<List<double>> a, List<List<double>> b) {
    int rows = a.length;
    int cols = a[0].length;

    // Initialize the result matrix with zeros
    List<List<double>> result =
        List.generate(rows, (_) => List.filled(cols, 0.0));

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        result[i][j] = a[i][j] + b[i][j];
      }
    }

    return result;
  }

  static List<double> _matrixVectorAdd(
      List<List<double>> matrix, List<double> vector) {
    int rows = matrix.length;
    int cols = matrix[0].length;

    if (vector.length != cols) {
      throw Exception('Matrix columns must match vector length');
    }

    // Initialize the result vector with zeros
    List<double> result = List.filled(rows, 0.0);

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        result[i] += matrix[i][j] + vector[j];
      }
    }

    return result;
  }

  static List<double> _vectorMatrixAdd(
      List<double> vector, List<List<double>> matrix) {
    int rows = matrix.length;
    int cols = matrix[0].length;

    if (vector.length != rows) {
      throw Exception('Vector length must match matrix rows');
    }

    // Initialize the result vector with zeros
    List<double> result = List.filled(cols, 0.0);

    for (int j = 0; j < cols; j++) {
      for (int i = 0; i < rows; i++) {
        result[j] += vector[i] + matrix[i][j];
      }
    }

    return result;
  }

  static List<double> _vectorAdd(List<double> a, List<double> b) {
    int length = a.length;

    if (b.length != length) {
      throw Exception('Vectors must be of the same length');
    }

    // Initialize the result vector with zeros
    List<double> result = List.filled(length, 0.0);

    for (int i = 0; i < length; i++) {
      result[i] = a[i] + b[i];
    }

    return result;
  }

  // Static method for matrix subtraction
  dynamic subtract(dynamic a, dynamic b) {
    if (a is List<List<double>> && b is List<List<double>>) {
      return _matrixSubtract(a, b);
    } else if (a is List<List<double>> && b is List<double>) {
      return _matrixVectorSubtract(a, b);
    } else if (a is List<double> && b is List<List<double>>) {
      return _vectorMatrixSubtract(a, b);
    } else if (a is List<double> && b is List<double>) {
      return _vectorSubtract(a, b);
    } else {
      throw Exception('Invalid types for subtraction');
    }
  }

  static List<List<double>> _matrixSubtract(
      List<List<double>> a, List<List<double>> b) {
    int rows = a.length;
    int cols = a[0].length;

    // Initialize the result matrix with zeros
    List<List<double>> result =
        List.generate(rows, (_) => List.filled(cols, 0.0));

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        result[i][j] = a[i][j] - b[i][j];
      }
    }

    return result;
  }

  static List<double> _matrixVectorSubtract(
      List<List<double>> matrix, List<double> vector) {
    int rows = matrix.length;
    int cols = matrix[0].length;

    if (vector.length != cols) {
      throw Exception('Matrix columns must match vector length');
    }

    // Initialize the result vector with zeros
    List<double> result = List.filled(rows, 0.0);

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        result[i] += matrix[i][j] - vector[j];
      }
    }

    return result;
  }

  static List<double> _vectorMatrixSubtract(
      List<double> vector, List<List<double>> matrix) {
    int rows = matrix.length;
    int cols = matrix[0].length;

    if (vector.length != rows) {
      throw Exception('Vector length must match matrix rows');
    }

    // Initialize the result vector with zeros
    List<double> result = List.filled(cols, 0.0);

    for (int j = 0; j < cols; j++) {
      for (int i = 0; i < rows; i++) {
        result[j] += vector[i] - matrix[i][j];
      }
    }

    return result;
  }

  static List<double> _vectorSubtract(List<double> a, List<double> b) {
    int length = a.length;

    if (b.length != length) {
      throw Exception('Vectors must be of the same length');
    }

    // Initialize the result vector with zeros
    List<double> result = List.filled(length, 0.0);

    for (int i = 0; i < length; i++) {
      result[i] = a[i] - b[i];
    }

    return result;
  }

  // Static method for matrix transpose
  List<dynamic> transpose(dynamic matrix) {
    if (matrix is List<List<double>>) {
      // If matrix is a 2D list
      int rows = matrix.length;
      int cols = matrix[0].length;

      // Initialize the transposed matrix with dimensions flipped
      List<List<double>> transposed =
          List.generate(cols, (_) => List.filled(rows, 0.0));

      for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
          transposed[j][i] = matrix[i][j];
        }
      }

      return transposed;
    } else if (matrix is List<double>) {
      // If matrix is a 1D list (vector), convert it to a column vector
      List<List<double>> transposed =
          List.generate(matrix.length, (index) => [matrix[index]]);
      return transposed;
    } else {
      throw ArgumentError('Input matrix type not supported');
    }
  }

  // Static method for matrix inverse
  List<dynamic> inverse(dynamic matrix) {
    if (matrix is List<List<double>>) {
      // If matrix is a 2D list
      if (matrix.length != matrix[0].length) {
        throw ArgumentError('Matrix must be square for inversion');
      }

      int n = matrix.length;
      List<List<double>> identity = List.generate(
          n, (i) => List.generate(n, (j) => (i == j ? 1.0 : 0.0)));

      // Create an augmented matrix [matrix | identity]
      List<List<double>> augmented =
          List.generate(n, (i) => List.from(matrix[i])..addAll(identity[i]));

      // Perform Gaussian elimination to obtain the inverse
      for (int i = 0; i < n; i++) {
        double pivot = augmented[i][i];
        for (int j = i; j < 2 * n; j++) {
          augmented[i][j] /= pivot;
        }
        for (int k = 0; k < n; k++) {
          if (k != i) {
            double factor = augmented[k][i];
            for (int j = 0; j < 2 * n; j++) {
              augmented[k][j] -= factor * augmented[i][j];
            }
          }
        }
      }

      // Extract the right half of the augmented matrix (the inverse)
      List<List<double>> inverseMatrix = [];
      for (int i = 0; i < n; i++) {
        inverseMatrix.add(augmented[i].sublist(n));
      }

      return inverseMatrix;
    } else {
      throw ArgumentError('Input matrix type not supported');
    }
  }
}
