const { ApolloServer } = require("apollo-server");
const { ApolloGateway, IntrospectAndCompose } = require("@apollo/gateway");

// Initialize an ApolloGateway instance and pass it the list your subgraph names and URLs
const gateway = new ApolloGateway({
  supergraphSdl: new IntrospectAndCompose({
    subgraphs: [
      { name: "products", url: "http://localhost:4001/" },
      { name: "reviews", url: "http://localhost:4002/" },
      { name: "inventory", url: "http://localhost:4003/" },
    ],
  }),
  debug: true,
});

// Pass the ApolloGateway to the ApolloServer constructor
const server = new ApolloServer({ gateway });


server.listen().then(({ url }) => {
  console.log(`🚀 Gateway ready at ${url}`);
}).catch(err => { console.error(err) });
1