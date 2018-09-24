import express from "express"
import adminOnly from "desktop/lib/admin_only"
import { buildServerApp } from "reaction/Artsy/Router/server"
import { routes } from "reaction/Apps/Artwork/routes"
import { renderLayout } from "@artsy/stitch"
import { Meta } from "./components/Meta"

const app = (module.exports = express())

app.get("/artwork2/:artworkID*", adminOnly, async (req, res, next) => {
  try {
    const { ServerApp, redirect, status } = await buildServerApp({
      routes,
      url: req.url,
    })

    if (redirect) {
      res.redirect(302, redirect.url)
      return
    }

    const layout = await renderLayout({
      basePath: __dirname,
      layout: "../../components/main_layout/templates/react_redesign.jade",
      config: {
        styledComponents: true,
      },
      blocks: {
        head: Meta,
        body: ServerApp,
      },
      locals: {
        ...res.locals,
        assetPackage: "artwork2",
        styledComponents: true,
      },
    })

    res.status(status).send(layout)
  } catch (error) {
    console.log(error)
    next(error)
  }
})

export default app
