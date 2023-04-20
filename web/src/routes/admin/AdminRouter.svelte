<script>
  import Router from 'svelte-spa-router'
  import AdminLogin from './AdminLogin.svelte'
  import AdminDashboard from './dashboard/AdminDashboard.svelte'
  import NotFound from '@/routes/NotFound.svelte'

  const prefix = '/admin'
  const routes = {
    '/login': AdminLogin,
    
    '/dashboard': AdminDashboard,
    '/dashboard/*': AdminDashboard,

    '*': NotFound
  }

  // Todo: add code to detect if logged in and automatically redirect to logged in dashboard
  // Similarly, automatically redirect to login if not logged in
</script>

<Router {prefix} {routes} />
