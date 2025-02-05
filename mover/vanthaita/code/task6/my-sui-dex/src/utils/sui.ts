// // utils/sui.ts
// import {
//   SuiClient,
//   SuiObjectResponse,
//   SuiObjectData,
// } from '@mysten/sui.js/client';
// import { normalizeSuiObjectId } from '@mysten/sui.js/utils';

// export async function getObjectByType(
//   suiClient: SuiClient,
//   objectType: string,
//   address: string | null = null,
// ) {
  
//   const normalizedObjectType = normalizeSuiObjectId(objectType);
//   let allObjects: SuiObjectData[] = [];
//   let cursor: string | null = null;

//   if (!address) {
//       return null
//   }

//   while (true) {
//       const objectsResponse = await suiClient.getObject({
//         id: "0x69cb9c8bf136a0da2d99f433be23038db622e235ddaf79d02a7f2b9b7e03b5d6"
//       });
//       console.log("Objects: ",objectsResponse)

//       // if (objectsResponse && objectsResponse.data && objectsResponse.data.length > 0) {
//       //     allObjects = [
//       //         ...allObjects,
//       //         ...objectsResponse.data
//       //             .map(obj => obj.data)
//       //             .filter((data): data is SuiObjectData => data !== null && data !== undefined)
//       //     ];
//       //     cursor = objectsResponse.nextCursor || null;
//       //     if (!cursor) {
//       //         break;
//       //     }
//       // } else {
//       //     break;
//       // }
//   }
//   // if (allObjects.length === 0) {
//   //     return null;
//   // }

//   // const objectDetailsResponse = await suiClient.multiGetObjects({
//   //     ids: allObjects.map(obj => obj.objectId),
//   //     options: {
//   //         showContent: true,
//   //     }
//   // });

//   // const finalData: SuiObjectData[] = objectDetailsResponse
//   //     .filter((obj): obj is SuiObjectResponse & { data: SuiObjectData } => obj.data !== null)
//   //     .map((obj) => obj.data);


//   // return finalData;
// }