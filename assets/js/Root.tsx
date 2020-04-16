import * as React from 'react'
import { BrowserRouter, Route, Switch } from 'react-router-dom'

import '@ionic/core/css/core.css';
import '@ionic/core/css/ionic.bundle.css';
import Header from './components/Header'
import HomePage from './pages'
import SideMenu from './components/SideMenu'

export default class Root extends React.Component {
  public render(): JSX.Element {
    return (
      <>
        <Header />
        <BrowserRouter>
          <SideMenu></SideMenu>
            <Switch>
              <Route exact path="/" component={HomePage} />
              <Route path="/tweet/:slug" component={TweetPage} />
              <Route path="/profile/:authorname" component={ProfilePage} />
              <Route path="/settings" component={SettingsPage} />
              <Route path="/newtweet" component={NewTweetPage} />
            </Switch>
        </BrowserRouter>
      </>
    )
  }
}
