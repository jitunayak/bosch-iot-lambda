const MISSING_ENV = "Envrionemt is not set for";

export const CONFIG = {
  TABLE_NAME: process.env.TABLE_NAME as string,
};

function validateEnvironment() {
  Object.entries(CONFIG).map((key) => {
    if (key[1] === undefined || key[1] === null)
      throw new Error(`${MISSING_ENV} ${key[0]}`); // throw error if any enviroment values are missing
  });
}

validateEnvironment();
