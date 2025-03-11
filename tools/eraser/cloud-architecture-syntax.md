# Eraser Cloud Architecture Syntax

## Node

A node is the most basic building block in a cloud architecture diagram.

Node definitions consist of a name followed by an optional set of properties. For example, compute is the name of below node and it has an icon property which is set to aws-ec2.

```
compute [icon: aws-ec2]
```

Node names are required to be unique.

Nodes support icon and color properties.

## Groups

A group is a container that can encapsulate nodes and groups.

Group definitions consist of a name followed by { }. For example, Main Server is the name of the below group and it contains Server and Data nodes.

```
Main Server {
    Server [icon: aws-ec2]
    Data [icon: aws-rds]
}
```

Group names are required to be unique.

Groups can be nested. In the below example, VPC Subnet group contains Main Server group.

```
VPC Subnet {
    Main Server {
        Server [icon: aws-ec2]
        Data [icon: aws-rds]
    }
}
```

Groups support icon and color properties.

## Properties

Properties are key-value pairs enclosed in [ ] brackets that can be appended to definitions of nodes and groups. Properties are optional.

It is possible to set multiple properties like shown below:

```
Main Server [icon: aws-ec2, color: blue] {
    Server [icon: aws-ec2]
    Data [icon: aws-rds]
}
```

Here are the properties that are allowed:

| Property  | Description           | Value                                                                                                                                     | Default value         |
| --------- | --------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- | --------------------- |
| icon      | Attached icons        | Icon names (e.g. aws-ec2). See Icons page for full list.                                                                                  |                       |
| color     | Stroke and fill color | Color name (e.g. blue) or hex code (e.g. "#000000"- note the quote marks for hex codes)                                                   |                       |
| label     | Text label            | Any string. Enclose in double quotes (e.g. "Main Server") if containing a space. Allows multiple nodes and groups to have the same label. | Name of node or group |
| colorMode | Fill color lightness  | pastel, bold, outline                                                                                                                     | pastel                |
| styleMode | Embellishments        | shadow, plain, watercolor                                                                                                                 | shadow                |
| typeface  | Text typeface         | rough, clean, mono                                                                                                                        | rough                 |

## Connections

Connections represent relationships between nodes and groups. They can be created between nodes, between groups, and between nodes and groups.

Here is an example of a connection between two nodes:

```
Compute > Storage
```

## Escape string

Certain characters are not allowed in node and group names because they are reserved. You can use these characters, you can wrap the entire node or group name in quotes " ".

```
User > "https://localhost:8080": GET
```

## Direction

The direction of the cloud architecture diagram can be changed using the direction statement. Allowed directions are:

direction down
direction up
direction right (default)
direction left
The direction statement can be placed anywhere in the code like this:

```
direction down
```

## Styling

Styles can be applied at the diagram level. Below is an overview of the options and syntax. Refer to Styling for more details and examples.

| Property  | Values                    | Default value | Syntax example   |
| --------- | ------------------------- | ------------- | ---------------- |
| colorMode | pastel, bold, outline     | pastel        | colorMode bold   |
| styleMode | shadow, plain, watercolor | shadow        | styleMode shadow |
| typeface  | rough, clean, mono        | rough         | typeface clean   |
