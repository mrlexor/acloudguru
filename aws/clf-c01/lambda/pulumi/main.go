package main

import (
	"github.com/pulumi/pulumi-aws/sdk/v4/go/aws/iam"
	"github.com/pulumi/pulumi-aws/sdk/v4/go/aws/lambda"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
)

func main() {
	pulumi.Run(func(ctx *pulumi.Context) error {
		// Create an IAM role.
		role, err := iam.NewRole(ctx, "myiam", &iam.RoleArgs{
			AssumeRolePolicy: pulumi.String(`{
				"Version": "2012-10-17",
				"Statement": [{
					"Sid": "",
					"Effect": "Allow",
					"Principal": {
						"Service": "lambda.amazonaws.com"
					},
					"Action": "sts:AssumeRole"
				}]
			}`),
		})
		if err != nil {
			return err
		}

		// Attach a policy to allow writing logs to CloudWatch
		logPolicy, err := iam.NewRolePolicy(ctx, "mylambda", &iam.RolePolicyArgs{
			Role: role.Name,
			Policy: pulumi.String(`{
                "Version": "2012-10-17",
                "Statement": [{
                    "Effect": "Allow",
                    "Action": [
                        "logs:CreateLogGroup",
                        "logs:CreateLogStream",
                        "logs:PutLogEvents"
                    ],
                    "Resource": "arn:aws:logs:*:*:*"
                }]
            }`),
		})

		// Set arguments for constructing the function resource.
		args := &lambda.FunctionArgs{
			Handler: pulumi.String("lambda_function.lambda_handler"),
			Role:    role.Arn,
			Runtime: pulumi.String("python3.9"),
			Code:    pulumi.NewFileArchive("./handlers/lambda_function.py.zip"),
		}

		// Create the lambda using the args.
		function, err := lambda.NewFunction(
			ctx,
			"myfunction",
			args,
			pulumi.DependsOn([]pulumi.Resource{logPolicy}),
		)
		if err != nil {
			return err
		}

		// Export the lambda ARN.
		ctx.Export("lambda", function.Arn)

		return nil
	})
}
