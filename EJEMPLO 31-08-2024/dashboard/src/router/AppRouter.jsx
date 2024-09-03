import {
    createBrowserRouter,
    RouterProvider,
} from 'react-router-dom';

import { HomeRoutes } from '../home';
import { LoginPage } from '../auth';
import { PublicRoute } from './PublicRoute';
import { Dashboard } from '../dashboard/pages/Dashboard';

const router = createBrowserRouter([
    {
      path: "login",
      element: <PublicRoute>
        <LoginPage />
      </PublicRoute>
    },
    {
      path: "dashboard",
      element: <PublicRoute>
        <Dashboard />
      </PublicRoute>
    },
    HomeRoutes,
]);

export const AppRouter = () => {
  return (
    <>
      <RouterProvider router={router} />
    </>
  )
}
