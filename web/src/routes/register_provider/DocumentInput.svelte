<script>
    import placeholder from "@/assets/placeholder.svg";

    let preview;
    export let name;

    function previewImage(e) {
        let reader = new FileReader()
        reader.readAsDataURL(e.target.files[0])
        reader.onload = (img) => {
            preview.src = img.target.result
        }
    }
</script>


<main>
    <img src={placeholder} class="center" bind:this={preview} id="uploadPreview" />
    
    <div class="center small-width field label prefix fill primary border">
        <i>add_photo_alternate</i>
        <input type="text">
        <input {name} type="file" on:change={previewImage} required>
        <label>Upload</label>
    </div>
</main>

<style>
    main {
        max-width: 100%;
        max-height: 50vh;
    }

    img {
        max-width: 100%;
        max-height: inherit;
    }
</style>
