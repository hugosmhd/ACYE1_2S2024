import { Navigate } from 'react-router-dom';
import { Navbar } from '../../ui'
import { ApagarPage, EncenderPage } from '../pages';
import { PrivateRoute } from '../../router/PrivateRoute';


export const HomeRoutes = {
    element: <PrivateRoute>
        <Navbar /> 
    </PrivateRoute>,
    children: [
    {  path: "encender",
        element: <EncenderPage />,
    },
    {
        path: "apagar",
        element: <ApagarPage />,
    },
    {
        // path: "/*",
        path: "/",
        element: <Navigate to="/encender" />,
    },
    ]
}