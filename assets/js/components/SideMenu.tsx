import * as React from 'react';
import { Link } from 'react-router-dom';

class SideMenu extends React.Component<any, any> {
  constructor(props: any){
    super(props);
    this.state = {
      isLoggedIn: localStorage.getItem("isLogin") ? localStorage.getItem("isLogin") :"false",
      routes: {
        addPages: [
          { title: 'Home', path: '/', icon: 'home' },
        ],
        loggedInPages: [
          { title: 'My Profile', path: '/profile/' + localStorage.getItem("username"), icon: 'person'},
          { title: 'New Tweet', path: '/newtweet', icon: 'create' },
          { title: 'Settings', path: '/settings', icon: 'settings' },
          { title: 'Logout', path: '/login', icon: 'log-out' }
        ],
        loggedOutPages: [
          { title: 'Login', path: '/login', icon: 'log-in' },
        ] }
    }
    window.addEventListener('loggedIn', (e: any) => {
      this.setState({
        isLoggedIn : e['detail'].toString(),
        routes : {
          addPages: [
            { title: 'Home', path: '/', icon: 'home' },
          ],
          loggedInPages: [
            { title: 'My Profile', path: '/profile/' + localStorage.getItem("username"), icon: 'person'},
            { title: 'New Tweet', path: '/newtweet', icon: 'create' },
            { title: 'Settings', path: '/settings', icon: 'settings' },
            { title: 'Logout', path: '/login', icon: 'log-out' }
          ],
          loggedOutPages: [
            { title: 'Login', path: '/login', icon: 'log-in' },
          ] }
      })

    });
  }

  renderMenuItem(menu: any) {
    return (
    <>
      <Link to={menu.path} >{menu.title}</Link>
    </>
    )
  }

  render() {
    return (
      <div style={{ flexDirection: 'column' }}>
      {this.state.routes.addPages.map((art: any) => this.renderMenuItem(art))}
      {this.state.isLoggedIn === "true" ? <> {this.state.routes.loggedInPages.map((art: any) =>
        this.renderMenuItem(art))} </> :<> {this.state.routes.loggedOutPages.map((art: any) =>
        this.renderMenuItem(art))} </> }
      </div>
      )
  }
}
export default SideMenu
