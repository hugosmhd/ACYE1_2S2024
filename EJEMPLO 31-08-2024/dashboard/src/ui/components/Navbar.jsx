import { useContext } from 'react';
import { NavLink, Outlet, useNavigate } from 'react-router-dom';
import { AuthContext } from '../../auth/context/AuthContext';


export const Navbar = () => {

    const { user, logout } = useContext(AuthContext);

    const navigate = useNavigate();

    const onLogout = () => {
        logout();
        
        navigate('/login', {
            replace: true
        });
    }

    return (
        <>
            <nav className="navbar navbar-expand-sm navbar-dark bg-dark p-2">
                <NavLink 
                    className="navbar-brand" 
                    to="/encender"
                >
                    Ejemplo
                </NavLink>

                <div className="navbar-collapse">
                    <div className="navbar-nav">

                        <NavLink 
                            className={({ isActive }) => `nav-item nav-link ${isActive ? 'active':''}`} 
                            to="/encender"
                        >
                            Encender
                        </NavLink>

                        <NavLink 
                            className={({ isActive }) => `nav-item nav-link ${isActive ? 'active':''}`} 
                            to="/apagar"
                        >
                            Apagar
                        </NavLink>

                    </div>
                </div>

                <div className="navbar-collapse collapse w-100 order-3 dual-collapse2 d-flex justify-content-end">
                    <ul className="navbar-nav ml-auto">
                        <span className='nav-item nav-link text-primary'>
                            { user?.name }
                        </span>

                        <button
                            className='nav-item nav-link btn'
                            onClick={onLogout}
                        >
                            Logout
                        </button>
                    </ul>
                </div>
            </nav>
            <div className='container'>
                <Outlet />
            </div>
        </>
    )
}