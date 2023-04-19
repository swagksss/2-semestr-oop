#include <iostream>
#include <vector>
#include <thread>
#include <algorithm>

using namespace std;

// Функція для виконання множення матриці для заданого діапазону рядків
void multiplyMatrixRange(const vector<vector<int>>& matrixA,
                         const vector<vector<int>>& matrixB,
                         vector<vector<int>>& matrixC,
                         int startRow,
                         int endRow)
{
    for (int i = startRow; i < endRow; ++i)
    {
        for (int j = 0; j < matrixB[0].size(); ++j)
        {
            matrixC[i][j] = 0;
            for (int k = 0; k < matrixA[0].size(); ++k)
            {
                matrixC[i][j] += matrixA[i][k] * matrixB[k][j];
            }
        }
    }
}

int main()
{
    // Вводимо розміри матриць
    int MATRIX_SIZE;
    cout << "Enter the size of matrices: ";
    cin >> MATRIX_SIZE;

    const int NUM_THREADS = 4;   // Кількість потоків для паралельного виконання

    // Ініціалізація матриці A і B випадковими значеннями
    vector<vector<int>> matrixA(MATRIX_SIZE, vector<int>(MATRIX_SIZE));
    vector<vector<int>> matrixB(MATRIX_SIZE, vector<int>(MATRIX_SIZE));
    cout << "Matrix A (Randomly Generated):" << endl;
    for (int i = 0; i < MATRIX_SIZE; ++i)
    {
        for (int j = 0; j < MATRIX_SIZE; ++j)
        {
            matrixA[i][j] = rand() % 10;
            cout << matrixA[i][j] << " ";
        }
        cout << endl;
    }
    cout << endl;

    cout << "Matrix B (Randomly Generated):" << endl;
    for (int i = 0; i < MATRIX_SIZE; ++i)
    {
        for (int j = 0; j < MATRIX_SIZE; ++j)
        {
            matrixB[i][j] = rand() % 10;
            cout << matrixB[i][j] << " ";
        }
        cout << endl;
    }
    cout << endl;

    // Ініціалізація матриці результатів C
    vector<vector<int>> matrixC(MATRIX_SIZE, vector<int>(MATRIX_SIZE, 0));

    // Створюємо і запускаємо кілька потоків для паралельного виконання
    vector<thread> threads;
    int range = MATRIX_SIZE / NUM_THREADS;
    for (int i = 0; i < NUM_THREADS; ++i)
    {
        int startRow = i * range;
        int endRow = (i == NUM_THREADS - 1) ? MATRIX_SIZE : startRow + range;
        threads.emplace_back(multiplyMatrixRange, ref(matrixA), ref(matrixB), ref(matrixC), startRow, endRow);
    }

    // Приєднуємо до всіх потоків, щоб дочекатися їх завершення
    for (auto& thread : threads)
    {
        thread.join();
    }

    // Виводимо матрицю результатів C
    cout << "Matrix C (Result of Matrix Multiplication):" << endl;
    for (int i = 0; i < MATRIX_SIZE; ++i)
    {
        for (int j = 0; j < MATRIX_SIZE; ++j)
        {
            cout << matrixC[i][j] << " ";
        }
        cout << endl;
    }

    return 0;
}
