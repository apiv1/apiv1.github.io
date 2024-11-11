```go
func MapList[T any, R any](slice []T, process func(T) R) []R {
	var result []R
	for _, v := range slice {
		processedValue := process(v)
		result = append(result, processedValue)
	}
	return result
}
```