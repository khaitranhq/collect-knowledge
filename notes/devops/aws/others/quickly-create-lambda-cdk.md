# 🚀 Create a lambda function quickly with AWS CDK

## 📋 Prerequisites

- AWS CLI version 2
- AWS SDK version 2
- Node.js 18.x or higher
- `Docker` or `esbuild`

## 📝 Sample application

1. 📁 Create a project directory for your new application.

```bash
mkdir hello-world
cd hello-world
```

2. 🛠️ Initialize the app.

```bash
cdk init app --language typescript
```

3. 📦 Add the `@types/aws-lambda` package as a development dependency. This package contains the type definitions for Lambda.

```bash
npm install -D @types/aws-lambda
```

4. ⚡ _(Optional)_ Install esbuild to speed up the build process and minify artifact.

```bash
npm install -D esbuild
```

5. 📂 Open the `lib` directory. You should see a file called `hello-world-stack.ts`. Create two new files in this directory: `hello-world.function.ts` and `hello-world.ts`.

6. ✏️ Open `hello-world.function.ts` and add the following code to the file. This is the code for the Lambda function.

> Note
> The import statement imports the type definitions from @types/aws-lambda. It does not import the aws-lambda NPM package, which is an unrelated third-party tool. For more information, see aws-lambda in the DefinitelyTyped GitHub repository.

```typescript
import { Context, APIGatewayProxyResult, APIGatewayEvent } from "aws-lambda";

export const handler = async (event: APIGatewayEvent, context: Context): Promise<APIGatewayProxyResult> => {
  console.log(`Event: ${JSON.stringify(event, null, 2)}`);
  console.log(`Context: ${JSON.stringify(context, null, 2)}`);
  return {
    statusCode: 200,
    body: JSON.stringify({
      message: "hello world",
    }),
  };
};
```

7. ✏️ Open hello-world.ts and add the following code to the file. This contains the NodejsFunction construct, which creates the Lambda function, and the LambdaRestApi construct, which creates the REST API.

```typescript
import { Construct } from "constructs";
import { NodejsFunction } from "aws-cdk-lib/aws-lambda-nodejs";
import { LambdaRestApi } from "aws-cdk-lib/aws-apigateway";

export class HelloWorld extends Construct {
  constructor(scope: Construct, id: string) {
    super(scope, id);
    const helloFunction = new NodejsFunction(this, "function");
    new LambdaRestApi(this, "apigw", {
      handler: helloFunction,
    });
  }
}
```
