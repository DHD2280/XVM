extern int patch_1_apply();

int patch_get_count() {
    return 1;
}

int patch_apply(int i) {
    int result = -100;

    switch (i) {
    case 1:
        result = patch_1_apply();
        break;
    default:
        break;
    }

    return result;
}
