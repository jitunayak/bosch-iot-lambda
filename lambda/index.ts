import { DynamoDB } from "aws-sdk";

const dynamo = new DynamoDB.DocumentClient();

exports.handler = async (event: any, context: any) => {
  const { serial_no } = JSON.parse(event?.body);

  try {
    const items = {
      serial_no: String(serial_no),
      timestamp: new Date().toISOString().toString(),
    };

    await dynamo
      .put({
        TableName: process.env.TABLE_NAME as string,
        Item: items,
        ConditionExpression: "attribute_not_exists(serial_no)",
      })
      .promise();

    const response = {
      statusCode: 200,
      body: JSON.stringify({ items }),
    };
    return response;
  } catch (error) {
    const response = {
      statusCode: 500,
      body: JSON.stringify({ error }),
    };
    return response;
  }
};
