import * as React from 'react'
import { BrowserRouter, Route, Switch } from 'react-router-dom'

import Header from './components/Header'
import HomePage from './pages'
import Counter from './components/Counter'
import LoginPage from './pages/Login';

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
          </Switch>
        </BrowserRouter>
      </>
    )
  }
}
