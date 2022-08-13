const BuildErrorResponse = (code: number, message: any) => {
  return {
    statusCode: code,
    body: JSON.stringify({
      message,
    }),
  };
};

const BuildSuccessResponse = (message: any) => {
  return {
    statusCode: 201,
    body: JSON.stringify({
      message,
    }),
  };
};

export { BuildErrorResponse, BuildSuccessResponse };
