import { useContext } from "react";
import { useNavigate } from "react-router-dom"
import { AuthContext } from "../context/AuthContext";


export const LoginPage = () => {

  const { login } = useContext(AuthContext);
  const navigate = useNavigate();

  const onLogin = () => {

    const lastPath = localStorage.getItem('lastPath') || '/';

    login('Sebastian Martínez');

    navigate(lastPath, {
      replace: true
    });

  }

  const onDashboard = () => {
    navigate('/dashboard');
  }

  return (
    <div className="container mt-5">
      <h1>Login</h1>
      <hr />

      <button
        className="btn btn-primary"
        onClick={onLogin}
      >
        Login
      </button>
      
      <button
        className="btn btn-secondary m-2"
        onClick={onDashboard}
      >
        Dashboard
      </button>
    </div>
  )
}
