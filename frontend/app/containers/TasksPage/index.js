/*
* HomePage
*
* This is the first thing users see of our App, at the '/' route
*
* NOTE: while this component should technically be a stateless functional
* component (SFC), hot reloading does not currently support SFCs. If hot
* reloading is not a neccessity for you then you can refactor it and remove
* the linting exception.
*/

import React from 'react';

import ClockModule from '../Modules/ClockModule';
import WeatherModule from '../Modules/WeatherModule';

export default class TasksPage extends React.Component { // eslint-disable-line react/prefer-stateless-function

  static propTypes = {
    moduleData: React.PropTypes.object,
  };

  constructor(props) {
    super(props);
  }

  componentWillMount() {
  }

  render() {
    return (
      <div>
        <div className="col-sm-12 clearfix">
          <div className="col-sm-6"><ClockModule {...this.props} layout="heading"/></div>
          <div className="col-sm-6"><WeatherModule {...this.props} layout="heading" moduleData={this.props.moduleData}/></div>
        </div>
      </div>
    );
  }
}
