/**
 *
 * App.react.js
 *
 * This component is the skeleton around the actual pages, and should only
 * contain code that should be seen on all pages. (e.g. navigation bar)
 *
 * NOTE: while this component should technically be a stateless functional
 * component (SFC), hot reloading does not currently support SFCs. If hot
 * reloading is not a neccessity for you then you can refactor it and remove
 * the linting exception.
 */

import React from 'react';
import { connect } from 'react-redux';
import { push } from 'react-router-redux';

class App extends React.Component { // eslint-disable-line react/prefer-stateless-function

  static propTypes = {
    children: React.PropTypes.node,
    changeRoute: React.PropTypes.func,
  };

  constructor(props) {
    super(props);

    this.state = {
      moduleData: {},
    };

    this.socket = new WebSocket('ws://localhost:8080/ws/v1/hud');
    this.socket.onmessage = (event) => {
      const moduleJSON = JSON.parse(event.data).module;
      const moduleName = moduleJSON.name;
      const moduleData = moduleJSON.data;

      this.setState({
        moduleData: {
          [moduleName]: moduleData,
        },
      });
    };
  }

  openRoute = (route) => {
    this.props.changeRoute(route);
  };

  openTasksPage = () => {
    this.openRoute('/tasks');
  };

  openHomePage = () => {
    this.openRoute('/');
  };

  render() {
    return (
      <div>
        <div className="col-sm-12">
          {React.cloneElement(this.props.children, { moduleData: this.state.moduleData })}
        </div>
        <div className="navbar navbar-default navbar-fixed-bottom">
          <div className="container-fluid">
            <div className="collapse navbar-collapse">
              <ul className="nav navbar-nav navbar-right">
                <li><a onClick={this.openHomePage}>Main</a></li>
                <li><a onClick={this.openTasksPage}>Tasks</a></li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    );
  }
}

function mapDispatchToProps(dispatch) {
  return {
    changeRoute: (url) => dispatch(push(url)),
  };
}

export default connect(null, mapDispatchToProps)(App);
