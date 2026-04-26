package com.pavan.i8n;

import java.util.stream.Stream;
import org.assertj.core.api.Assertions;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;

/**
 * The type Practice.
 *
 * @author gumparthypavankumar[pk] created on 22/11/25
 */
class PracticeTest {
  int minOperations(int i, int j, String word1, String word2, int[][] memo) {
    if (i == word1.length()) {
      return word2.length() - j; // delete
    }
    if (j == word2.length()) {
      return word1.length() - i; // add
    }

    if (memo[i][j] != -1) {
      return memo[i][j];
    }

    if (word1.charAt(i) == word2.charAt(j)) {
      return memo[i][j] = minOperations(i + 1, j + 1, word1, word2, memo);
    }


    int addOp = 1 + minOperations(i + 1, j, word1, word2, memo);
    int replaceOp = 1 + minOperations(i + 1, j + 1, word1, word2, memo);
    int deleteOp = 1 + minOperations(i, j + 1, word1, word2, memo);

    return memo[i][j] = Math.min(addOp, Math.min(replaceOp, deleteOp));
  }

  int minDistance(String word1, String word2) {
    int n = word1.length();
    int m = word2.length();

    if (n == 0) {
      return m;
    }
    if (m == 0) {
      return n;
    }

    int[] nextRow = new int[m + 1];
    int[] currentRow = new int[m + 1];

    for (int i = 0; i <= m; i++) {
      nextRow[i] = m - i;
    }

    for (int i = n - 1; i >= 0; i--) {
      currentRow[m] = n - i;
      for (int j = m - 1; j >= 0; j--) {
        if (word1.charAt(i) == word2.charAt(j)) {
          currentRow[j] = nextRow[j + 1];
        }
        else {
          int addOp = 1 + nextRow[j];
          int replaceOp = 1 + nextRow[j + 1];
          int deleteOp = 1 + currentRow[j + 1];

          currentRow[j] = Math.min(addOp, Math.min(replaceOp, deleteOp));
        }
      }
      int[] temp = nextRow;
      nextRow = currentRow;
      currentRow = temp;
    }

    return nextRow[0];
  }

  @ParameterizedTest(name = "{0}")
  @MethodSource(value = "getInputsForMinOperationsEditDistance")
  void minOperationsForEditDistance(String name, String word1, String word2, int expected) {
    final int result = minDistance(word1, word2);
    Assertions.assertThat(result).isEqualTo(expected);
  }

  private static Stream<Arguments> getInputsForMinOperationsEditDistance() {
    return Stream.of(
        Arguments.of("Test Case 1", "horse", "ros", 3),
        Arguments.of("Test Case 2", "intention", "execution", 5)
    );
  }
}
