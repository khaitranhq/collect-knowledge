# Intrinsic Functions in Amazon State Language

## What is intrinsic function?

Intrinsic functions are constructs that look similar to functions in programming languages. They can be used to help payload builders process the data going to and from the Resource field of a Task state.

## Fields that support

- **Pass state :** Parameters
- **Task state :** Parameters, ResultSelector, Credentials
- **Parallel state:** Parameters, ResultSelector
- **Map state:** Parameters, ResultSelector

## Types

### Intrinsic functions for arrays

Intrinsic functions for arrays allow you to manipulate array data within your Amazon State Language definitions. Here are some examples:

- **States.Array**: Creates an array from the provided arguments.
- **States.ArrayContains**: Checks if an array contains a specific value.
- **States.ArrayGetItem**: Retrieves an item from an array at a specified index.
- **States.ArrayLength**: Returns the length of an array.
- **States.ArrayPartition**: Splits an array into multiple arrays of a specified size.
- **States.ArrayRange**: Creates an array containing a range of numbers.
- **States.ArrayUnique**: Removes duplicate values from an array.

#### Example

```json
{
  "Type": "Pass",
  "Parameters": {
    "array.$": "States.Array(1, 2, 3, 4, 5)",
    "containsThree.$": "States.ArrayContains($.array, 3)",
    "thirdItem.$": "States.ArrayGetItem($.array, 2)",
    "arrayLength.$": "States.ArrayLength($.array)",
    "partitionedArray.$": "States.ArrayPartition($.array, 2)",
    "rangeArray.$": "States.ArrayRange(1, 5, 1)",
    "uniqueArray.$": "States.ArrayUnique([1, 2, 2, 3, 4, 4, 5])"
  },
  "ResultPath": "$.result",
  "End": true
}
```

### Intrinsic functions for encoding/decoding

Intrinsic functions for encoding/decoding allow you to encode and decode data within your Amazon State Language definitions. Here are some examples:

- **States.Base64Encode**: Encodes a string to Base64.
- **States.Base64Decode**: Decodes a Base64 string.

#### Example

```json
{
  "Type": "Pass",
  "Parameters": {
    "encodedString.$": "States.Base64Encode('Hello World')",
    "decodedString.$": "States.Base64Decode($.encodedString)"
  },
  "ResultPath": "$.result",
  "End": true
}
```

### Intrinsic functions for hash calculation

Intrinsic functions for hash calculation allow you to compute hash values within your Amazon State Language definitions. Here are some examples:

- **States.Hash**: Computes a hash value using a specified algorithm.

#### Example

```json
{
  "Type": "Pass",
  "Parameters": {
    "hashValue.$": "States.Hash('Hello World', 'SHA-256')"
  },
  "ResultPath": "$.result",
  "End": true
}
```

### Intrinsic functions for JSON data manipulation

Intrinsic functions for JSON data manipulation allow you to manipulate JSON data within your Amazon State Language definitions. Here are some examples:

- **States.JsonMerge**: Merge 2 JSON objects to a single object.
- **States.JsonToString**: Converts a JSON object to a string.
- **States.StringToJson**: Converts a string to a JSON object.

#### Example

```json
{
  "Type": "Pass",
  "Parameters": {
    "jsonString.$": "States.JsonToString({\"key\": \"value\"})",
    "jsonObject.$": "States.StringToJson($.jsonString)"
  },
  "ResultPath": "$.result",
  "End": true
}
```

### Intrinsic functions for Math operations

Intrinsic functions for Math operations allow you to perform mathematical calculations within your Amazon State Language definitions. Here are some examples:

- **States.MathRandom**: Return a random number between start number and end number
- **States.MathAdd**: Adds two numbers.

#### Example

```json
{
  "Type": "Pass",
  "Parameters": {
    "sum.$": "States.MathAdd(1, 2)",
  },
  "ResultPath": "$.result",
  "End": true
}
```

### Intrinsic functions for String operations

Intrinsic functions for String operations allow you to manipulate string data within your Amazon State Language definitions. Here are some examples:

- **States.StringSplit**: Splits a string into an array of substrings.

#### Example

```json
{
  "Type": "Pass",
  "Parameters": {
    "splitString.$": "States.StringSplit('a,b,c', ',')",
  },
  "ResultPath": "$.result",
  "End": true
}
```

### Intrinsic functions for UUID

Intrinsic functions for UUID allow you to generate UUIDs within your Amazon State Language definitions. Here are some examples:

- **States.UUID**: Generates a UUID.

#### Example

```json
{
  "Type": "Pass",
  "Parameters": {
    "uuid.$": "States.UUID()"
  },
  "ResultPath": "$.result",
  "End": true
}
```

### Intrinsic functions for generic operations

Intrinsic functions for generic operations allow you to perform various generic operations within your Amazon State Language definitions. Here are some examples:

- **States.Format**: Formats a string using specified arguments.

#### Example

```json
{
  "Type": "Pass",
  "Parameters": {
    "formattedString.$": "States.Format('Hello, {}!', 'World')"
  },
  "ResultPath": "$.result",
  "End": true
}
```

## Reference
- [Intrinsic functions in Amazon States Language for Step Functions workflows](https://docs.aws.amazon.com/step-functions/latest/dg/intrinsic-functions.html)
