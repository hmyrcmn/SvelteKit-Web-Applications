// src/routes/store.js
import { writable } from "svelte/store";

export const evler = writable([
  {
    id: 1,
    ad: "Ev 1",
    odalar: [
      {
        id: 1,
        ad: "Oda 1",
        prizler: [
          { id: 1, ad: "Priz 1", durum: false },
          { id: 2, ad: "Priz 2", durum: true },
        ],
      },
    ],
  },
]);
