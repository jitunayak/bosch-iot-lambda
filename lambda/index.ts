import { DynamoDB } from "aws-sdk";
import { BuildErrorResponse, BuildSuccessResponse } from "./helper";

const dynamo = new DynamoDB.DocumentClient();

exports.handler = async (event: any, context: any) => {
  console.log("incoming event in index", { event });

  const TABLE_NAME = process.env.TABLE_NAME as string;
  const { serial_no } = JSON.parse(event?.body);

  try {
    const items = {
      serial_no: String(serial_no),
      timestamp: new Date().toISOString().toString(),
    };

    await dynamo
      .put({
        TableName: TABLE_NAME,
        Item: items,
        ConditionExpression: "attribute_not_exists(serial_no)",
      })
      .promise();

    const successMsg = `Registered IOT device ${JSON.stringify(
      items
    )} in ${TABLE_NAME}`;

    return BuildSuccessResponse(successMsg);
  } catch (error: any) {
    console.log(error);
    if (error?.code === "ConditionalCheckFailedException") {
      const errorMsg = `Device with serial number ${serial_no} already registered`;
      return BuildErrorResponse(400, errorMsg);
    }
    return BuildErrorResponse(500, error);
  }
};
