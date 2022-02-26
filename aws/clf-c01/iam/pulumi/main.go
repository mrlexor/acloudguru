package main

import (
	"github.com/pulumi/pulumi-aws/sdk/v4/go/aws/iam"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
)

func main() {
	pulumi.Run(func(ctx *pulumi.Context) error {
		group, err := iam.NewGroup(ctx, "group", &iam.GroupArgs{
			Name: pulumi.String("developers"),
		})
		if err != nil {
			return err
		}

		_, err = iam.NewGroupMembership(ctx, "main", &iam.GroupMembershipArgs{
			Group: group.Name,
			Users: pulumi.StringArray{
				pulumi.String("developer-1"),
				pulumi.String("developer-2"),
				pulumi.String("developer-3"),
				pulumi.String("developer-4"),
			},
		})
		if err != nil {
			return err
		}

		_, err = iam.NewPolicyAttachment(ctx, "main", &iam.PolicyAttachmentArgs{
			PolicyArn: pulumi.String("arn:aws:iam::aws:policy/AWSLambda_FullAccess"),
			Groups: pulumi.Array{
				group.Name,
			},
		})
		if err != nil {
			return err
		}

		return nil
	})
}
