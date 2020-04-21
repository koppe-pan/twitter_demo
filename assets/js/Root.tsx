import * as React from 'react'
import { BrowserRouter, Route, Switch } from 'react-router-dom'

import Header from './components/Header'
import HomePage from './pages/HomePage'
import Counter from './components/Counter'
import LoginPage from './pages/Login';
import Profile from './pages/Profile';
import TweetPage from './pages/TweetPage';
import NewTweet from './pages/NewTweet';
import SettingsPage from './pages/Settings';
import SideMenu from './components/SideMenu';

export default class Root extends React.Component {
  public render(): JSX.Element {
    return (
      <>
        <Header />
        <BrowserRouter>
          <Switch>
            <Route exact path="/" component={HomePage} />
            <Route path="/counter" component={ Counter } />
            <Route exact path="/login" component={LoginPage} />
            <Route path="/profile/:authorname" component={ Profile } />
            <Route path="/tweetpage/:slug" component={ TweetPage } />
            <Route path="/newtweet" component={ NewTweet } />
            <Route path="/settings" component={ SettingsPage } />
          </Switch>
          <SideMenu></SideMenu>
        </BrowserRouter>
      </>
    )
  }
}
