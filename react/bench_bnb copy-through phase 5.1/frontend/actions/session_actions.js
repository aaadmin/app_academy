import * as ApiUtil from '../util/session_api_util';

export const RECEIVE_CURRENT_USER = 'RECEIVE_CURRENT_USER';
export const RECEIVE_ERRORS = 'RECEIVE_ERRORS';

export const signUp = user => dispatch => {
  ApiUtil.signUp(user)
    .then(userPromise => {
      dispatch(receiveCurrentUser(userPromise));
    }, errors => {
      console.log(errors);
    });
};

export const signIn = user => dispatch => {
  ApiUtil.signIn(user)
    .then(userPromise => {
      dispatch(receiveCurrentUser(userPromise));
    }, errors => {
      console.log(errors);
    });
};

export const signOut = () => dispatch => {
  ApiUtil.signOut()
    .then(() => {
      dispatch(receiveCurrentUser(null));
    }, errors => {
      console.log(errors);
    });
};

export const receiveCurrentUser = currentUser => {
  return {
    type: RECEIVE_CURRENT_USER,
    currentUser: currentUser,
    errors: []
  };
};

export const receiveErrors = errors => {
  return {
    type: RECEIVE_ERRORS,
    currentUser: null,
    errors: errors
  };
};
