package main

import (
	"github.com/pulumi/pulumi-aws/sdk/v4/go/aws/ec2"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
)

func main() {
	pulumi.Run(func(ctx *pulumi.Context) error {
		// Create VPC
		vpc, err := ec2.NewVpc(ctx, "main", &ec2.VpcArgs{
			CidrBlock: pulumi.String("10.0.0.0/16"),

			Tags: pulumi.StringMap{
				"Name": pulumi.String("my-vpc"),
			},
		})

		// Create subnet
		subnet, err := ec2.NewSubnet(ctx, "main", &ec2.SubnetArgs{
			VpcId:               vpc.ID(),
			CidrBlock:           pulumi.String("10.0.0.0/24"),
			AvailabilityZone:    pulumi.String("us-east-1a"),
			MapPublicIpOnLaunch: pulumi.Bool(true),

			Tags: pulumi.StringMap{
				"Name": pulumi.String("my-public-subnet"),
			},
		})

		// Create internate gateway
		ig, err := ec2.NewInternetGateway(ctx, "main", &ec2.InternetGatewayArgs{
			VpcId: vpc.ID(),

			Tags: pulumi.StringMap{
				"Name": pulumi.String("my-internet-gateway"),
			},
		})

		// Create route table
		rt, err := ec2.NewRouteTable(ctx, "main", &ec2.RouteTableArgs{
			VpcId: vpc.ID(),
			Routes: ec2.RouteTableRouteArray{
				&ec2.RouteTableRouteArgs{
					CidrBlock: pulumi.String("0.0.0.0/0"),
					GatewayId: ig.ID(),
				},
			},

			Tags: pulumi.StringMap{
				"Name": pulumi.String("publicRT"),
			},
		})

		_, err = ec2.NewRouteTableAssociation(ctx, "routeTableAssociation", &ec2.RouteTableAssociationArgs{
			SubnetId:     subnet.ID(),
			RouteTableId: rt.ID(),
		})

		// Create security group
		sec_group, err := ec2.NewSecurityGroup(ctx, "main", &ec2.SecurityGroupArgs{
			Description: pulumi.String("Allow SSH"),
			VpcId:       vpc.ID(),

			Ingress: ec2.SecurityGroupIngressArray{
				&ec2.SecurityGroupIngressArgs{
					Description: pulumi.String("SSH"),
					FromPort:    pulumi.Int(22),
					ToPort:      pulumi.Int(22),
					Protocol:    pulumi.String("tcp"),
					CidrBlocks: pulumi.StringArray{
						pulumi.String("0.0.0.0/0"),
					},
				},
			},

			Egress: ec2.SecurityGroupEgressArray{
				&ec2.SecurityGroupEgressArgs{
					FromPort: pulumi.Int(0),
					ToPort:   pulumi.Int(0),
					Protocol: pulumi.String("-1"),
					CidrBlocks: pulumi.StringArray{
						pulumi.String("0.0.0.0/0"),
					},
					Ipv6CidrBlocks: pulumi.StringArray{
						pulumi.String("::/0"),
					},
				},
			},

			Tags: pulumi.StringMap{
				"Name": pulumi.String("my-sg"),
			},
		})

		// Create EC2 instance
		amzn2, err := ec2.LookupAmi(ctx, &ec2.LookupAmiArgs{
			Filters: []ec2.GetAmiFilter{
				ec2.GetAmiFilter{
					Name: "name",
					Values: []string{
						"amzn2-ami-kernel-5.10-hvm-2.0.20220207.1-x86_64-gp2",
					},
				},
			},

			Owners: []string{
				"amazon",
			},
		}, nil)

		_, err = ec2.NewInstance(ctx, "main", &ec2.InstanceArgs{
			Ami:              pulumi.String(amzn2.Id),
			InstanceType:     pulumi.String("t2.micro"),
			AvailabilityZone: pulumi.String("us-east-1a"),
			SubnetId:         subnet.ID(),

			SecurityGroups: pulumi.StringArray{
				sec_group.ID().ToStringOutput(),
			},

			Tags: pulumi.StringMap{
				"Name": pulumi.String("my-vpc"),
			},
		})

		if err != nil {
			return err
		}

		return nil
	})
}
