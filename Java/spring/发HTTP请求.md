RestTemplate.postForObject()
```java
private String postForObject(String requestUrl, String requestContent) {
    HttpHeaders httpHeaders = new HttpHeaders();
    httpHeaders.add("Content-Type", "application/json");
    HttpEntity<String> request = new HttpEntity<>(requestContent, httpHeaders);

    RestTemplate restTemplate = new RestTemplate();
    String responseContent = restTemplate.postForObject(requestUrl, request, String.class);

    return responseContent;
}
```