<script>
  import Router, { replace } from 'svelte-spa-router'
  import wrap from 'svelte-spa-router/wrap'
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
</script>

<Router {prefix} {routes} />
